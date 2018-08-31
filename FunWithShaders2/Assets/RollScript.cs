using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets
{
    [ExecuteInEditMode]
    public class RollScript : MonoBehaviour
    {
        // Update is called once per frame
        void FixedUpdate()
        {
            this.transform.Rotate(0, 2, 0);
        }
    }
}
