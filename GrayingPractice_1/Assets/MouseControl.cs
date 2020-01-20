using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseControl : MonoBehaviour
{
    public GameObject pic;

    Material picMat;
    float dis = 0;

    void Start()
    {
        picMat = pic.GetComponent<SpriteRenderer>().material;
    }


    void Update()
    {
        dis += Input.GetAxis("Mouse ScrollWheel") * 0.5f;
        if (dis < 0)
        {
            dis = 0;
        }
        if (Input.GetMouseButton(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 1000.0f))
            {
                picMat.SetFloat("_Radius", dis);
                picMat.SetVector("_Position", hit.point);
            }
        }


    }
}
