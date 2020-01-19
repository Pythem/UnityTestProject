using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionVertexController : MonoBehaviour
{
    private Transform trans;
    private Material[] mats;
    private Vector3 lastPosition;
    private Vector3 newPosition;
    private Vector3 direction;
    private float t = 0;

    public float MoveSpeed = 1;

    void Start()
    {
        trans = transform;
        lastPosition = newPosition = transform.position;

        var renderers = trans.GetComponentsInChildren<Renderer>();

        mats = new Material[renderers.Length];
        for (int i = 0; i < renderers.Length; i++)
        {
            mats[i] = renderers[i].sharedMaterial;
        }
    }

    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            transform.Translate(Vector3.forward * Time.deltaTime * MoveSpeed);
        }
        if (Input.GetKey(KeyCode.A))
        {
            transform.Translate(Vector3.left * Time.deltaTime * MoveSpeed);
        }
        if (Input.GetKey(KeyCode.S))
        {
            transform.Translate(Vector3.back * Time.deltaTime * MoveSpeed);
        }
        if (Input.GetKey(KeyCode.D))
        {
            transform.Translate(Vector3.right * Time.deltaTime * MoveSpeed);
        }

        newPosition = trans.position;

        if (newPosition == lastPosition)
            t = 0;

        t += Time.deltaTime;

        lastPosition = Vector3.Lerp(lastPosition, newPosition, t / 2);

        direction = lastPosition - newPosition;

        foreach (var m in mats)
        {
            m.SetVector("_Direction", new Vector4(direction.x, direction.y, direction.z, m.GetVector("_Direction").w));
        }

    }
}
